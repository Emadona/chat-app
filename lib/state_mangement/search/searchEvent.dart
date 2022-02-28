
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable{
  const SearchEvent();


  @override
  List<Object> get props => [];
}

class SearchSend extends SearchEvent{
  final String name;
  const SearchSend(this.name);

  @override
  List<Object> get props => [name];

}