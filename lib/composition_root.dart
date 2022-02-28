// @dart=2.9
import 'package:chat/ui/pages/message_thread/message_thread_router.dart';
import 'package:chatapp/chat.dart';
import 'package:chat/cache/local_cache.dart';
import 'package:chat/data/datasource/datasource_contract.dart';
import 'package:chat/data/datasource/sqflite_datasource.dart';
import 'package:chat/data/factories/db_factory.dart';
import 'package:chat/data/services/image_uploader.dart';
import 'package:chat/state_mangement/home/chats_cubit.dart';
import 'package:chat/state_mangement/home/home_cubit.dart';
import 'package:chat/state_mangement/is_like/is_like_bloc.dart';
import 'package:chat/state_mangement/message/message_bloc.dart';
import 'package:chat/state_mangement/message_thread/message_thread_cubit.dart';
import 'package:chat/state_mangement/onboarding/onboarding_cubit.dart';
import 'package:chat/state_mangement/onboarding/profile_image_cubit.dart';
import 'package:chat/state_mangement/receipt/receipt_bloc.dart';
import 'package:chat/state_mangement/search/search_bloc.dart';
import 'package:chat/state_mangement/typing/typing_notification_bloc.dart';
import 'package:chat/state_mangement/weather/weather_bloc.dart';
import 'package:chat/ui/pages/home/home_router.dart';
import 'package:chat/ui/pages/message_thread/message_thread.dart';
import 'package:chat/ui/pages/onboarding/onboarding.dart';
import 'package:chat/viewmodels/chat_view_model.dart';
import 'package:chat/viewmodels/chats_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_weather_api/meta_weather_api.dart';
// import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'state_mangement/active_users/active_users_bloc.dart';
import 'state_mangement/life_cycle_cubit/life_cycle_cubit.dart';
import 'ui/pages/home/home.dart';
import 'ui/pages/life_cycle_manager.dart';
import 'ui/pages/onboarding/onboarding_router.dart';

class CompositionRoot {
  // static Rethinkdb _r;
  // static Connection _connection;
  static IUserService _userService;
  static Database _db;
  static IMessageService _imessageService;
  static IDatasource _datasource;
  static WebServices _webServices;
  static WeatherRepository _weatherRepository;
  static WeatherBloc _weatherBloc;
  static ILocalCache _localCache;
  static MessageBloc _messageBloc;
  static ITypingNotification _typingNotification;
  static TypingNotificationBloc _typingNotificationBloc;
  static ChatsCubit _chatsCubit;
  static SearchBloc _searchBloc;
  static UserBloc _userBloc;
  static User me;
  static Map id;
  // static GameBloc _gameBloc;
  // static ITicTacToyService _ticTacToyServices;
  // static TicTacBloc _ticTacBloc;

  static configure() async {
    // _r = Rethinkdb();
    // try {
    //   _connection =
    //   await _r.connect(user: 'admin',
    //       db: 'test',
    //       host: 'dockhero-pointy-80877.dockhero.io',
    //       password: 'Al3almy10');
    // }catch (e){
    //  print(e);
    // }
    // _connection = await _r.connect(host: 'ec2-54-242-183-41.compute-1.amazonaws.com');
    _userService = UserFirebase();
    _userBloc = UserBloc(_userService);
    _imessageService = MessageFirebase();
    _typingNotification = TypingNotificationFirebase(_userService);
    _db = await LocalDatabaseFactory().createDatabase();
    _datasource = SqfliteDatasource(_db);
    final sp = await SharedPreferences.getInstance();
    _localCache = LocalCache(sp);
    _messageBloc = MessageBloc(_imessageService);
    _typingNotificationBloc = TypingNotificationBloc(_typingNotification);
    final viewMode = ChatsViewModel(_datasource, _userService);
    _chatsCubit = ChatsCubit(viewMode);
    _searchBloc = SearchBloc(_userService);
    _webServices = WebServices();
    _weatherRepository = WeatherRepository(_webServices);
    _weatherBloc = WeatherBloc(_weatherRepository);
    id = await _localCache.fetch('USER');
    me = User.fromJson(id, id['id']);
  }

  static Widget start() {
    final user = _localCache.fetch('USER');
    return user.isEmpty
        ? composeOnboardingUi()
        : composeLifeCycle(composeHomeUi(User.fromJson(user, user['id'])),
            User.fromJson(user, user['id']));
  }

  static Widget composeOnboardingUi() {
    OnboardingCubit onboardingCubit =
        OnboardingCubit(_userService, _localCache);
    ProfileImageCubit imageCubit = ProfileImageCubit();
    IOnboardingRouter router = OnboardingRouter(composeHomeUi);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => onboardingCubit),
      BlocProvider(create: (BuildContext context) => imageCubit),
    ], child: Onboarding(router));
  }

  // static Widget composeGameProsses() {
  //   IGameProsses router = GameProsses(showGameBoard: composeGameBoard);
  //   return MultiBlocProvider(
  //     providers: [
  //       BlocProvider(create: (BuildContext context) => _gameBloc),
  //
  //     ],
  //     child: GameProcessPage(router),
  //   );
  // }


  static Widget composeHomeUi(User me) {
    IReceiptService receiptService = ReceiptFirebase();
    ReceiptBloc receiptBloc = ReceiptBloc(receiptService);
    HomeCubit homeCubit = HomeCubit(_userService, _localCache);
    IHomeRouter router = HomeRouter(showMessageThread: composeMessageThreadUi);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => _userBloc),
        BlocProvider(create: (BuildContext context) => receiptBloc),
        BlocProvider(create: (BuildContext context) => homeCubit),
        BlocProvider(create: (BuildContext context) => _messageBloc),
        BlocProvider(create: (BuildContext context) => _typingNotificationBloc),
        BlocProvider(create: (BuildContext context) => _chatsCubit),
        BlocProvider(create: (BuildContext context) => _searchBloc),


      ],
      child: Home(me, router),
    );
  }


  static Widget composeLifeCycle(Widget home, User me) {
    LifeCycleCubit lifeCycleCubit = LifeCycleCubit(_userService, _localCache);
    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (BuildContext context) => _userBloc),
        BlocProvider(create: (BuildContext context) => lifeCycleCubit),
        // BlocProvider(create: (BuildContext context) => _messageBloc),
        // BlocProvider(create: (BuildContext context) => _chatsCubit)
      ],
      child: LifeCycleManager(home, me),
    );
  }

  static Widget composeMessageThreadUi(User receiver, User me,
      {String chatId}) {
    ChatViewModel viewModel = ChatViewModel(_datasource);
    MessageThreadCubit messageThreadCubit =
        MessageThreadCubit(viewModel, _localCache, _userService);
    IReceiptService receiptService = ReceiptFirebase();
    IIsLikeService isLikeService = IsLikeFirebase();
    IsLikeBloc isLikeBloc = IsLikeBloc(isLikeService);
    ReceiptBloc receiptBloc = ReceiptBloc(receiptService);
    IMessageThreadRouter router = MessageThreadRouter();

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => messageThreadCubit),
          BlocProvider(create: (BuildContext context) => receiptBloc),
          BlocProvider(create: (BuildContext context) => isLikeBloc),
          BlocProvider(create: (BuildContext context) => _weatherBloc),

        ],
        child: MessageThread(
            receiver, me, _messageBloc, _chatsCubit, _typingNotificationBloc,
            router,
            chatId: chatId));
  }
}
