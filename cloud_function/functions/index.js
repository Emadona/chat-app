const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();


exports.handleChallenge=functions.https.onRequest(async (request, response) =>{
  const senderId = request.query.senderId;
  const senderName = request.query.senderName;
  const senderFcmToken = request.query.senderFcmToken;
  const receiverFcmToken = request.query.receiverFcmToken;
  const receiverId = request.query.receiverId;
  const receiverName = request.query.receiverName;
  const handleType = request.query.handleType;
  if (handleType === "challenge") {
    const message = {
      data: {
        senderId: senderId,
        senderName: senderName,
        senderFcmToken: senderFcmToken,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        notificationType: "challenge",
      },
      notification: {
        title: "Tic Tac Toe Challenge",
        body: "You just got a challenge from " + senderName,
      },
      token: receiverFcmToken,
    };
    try {
      await admin.messaging().send(message);
      console.log("Successfully sent message:");
      return response.send(true);
    } catch (error) {
      console.log("Error sending message:", error);
      return response.send(false);
    }
  } else if (handleType === "accept") {
    const gameId = receiverId + "_" + senderId;
    console.log(gameId);
    let notificationMessage;
    try {
      const docSnapshot = admin.firestore()
          .collection("games").doc(gameId).get();
      if (!docSnapshot.exists || (docSnapshot.exists && docSnapshot.data().
          winner !== "")) {
        console.log("enter to creating function");
        await _createGame(gameId, receiverId, receiverName, receiverFcmToken,
            senderId, senderName, senderFcmToken);
        console.log("here you go");
        notificationMessage = "Your game has been started!!!";
      } else {
        notificationMessage = "Your game is being continued!!!";
      }
      console.log(notificationMessage);
      _changeGamePlayersState(senderId, receiverId, "playing");
      const message = {
        data: {
          gameId: gameId,
          player1Id: receiverId,
          player2Id: senderId,
          player1Name: receiverName,
          player2Name: senderName,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          notificationType: "started",
        },
        notification: {
          title: "Game Started",
          body: notificationMessage,
        },
      };
      await admin.messaging().sendToDevice([senderFcmToken,
        receiverFcmToken], message);// move
      return response.send(true);
    } catch (err) {
      console.log("Error subscribing to topic:", err);
      return response.send(false);
    }
  } else if (handleType === "reject") {
    const message = {
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        notificationType: "rejected",
      },
      notification: {
        title: "Challenge Rejected!!",
        body: senderName + " rejected your challenge.",
      },
      token: receiverFcmToken,
    };
    try {
      await admin.messaging().send(message);
      return response.send(true);
    } catch (err) {
      return response.send(false);
    }
  } else {
    return response.send(false);
  }
});

exports.playPiece = functions.https.onRequest(async (request, response) => {
  console.log("In play Piece .........");
  try {
    const gameId = request.query.gameId;
    const playerId = request.query.playerId;
    const position = request.query.position;
    let piece = "";
    const pieceUpdateKey = "pieces." + position;
    let scoreUpdateKey = "";
    let playersCurrentScore = 0;
    const game = await admin.firestore().collection("games").doc(gameId).get();
    let gameData = {};
    if (game.exists && game.data().currentPlayer === playerId) {
      gameData = game.data();
      console.log("The collection response", game.data());
      // change the currentPLayer
      let nextPlayer = "";
      //  TODO: refactor this and use gameData['player1'].gamePiece
      if (gameData.currentPlayer === gameData.player1.user.id) {
        nextPlayer = gameData.player2.user.id;
        piece = gameData.player1.gamePiece;
        scoreUpdateKey = "player1.score";
        playersCurrentScore = gameData.player1.score;
      } else {
        nextPlayer = gameData.player1.user.id;
        piece = gameData.player2.gamePiece;
        scoreUpdateKey = "player2.score";
        playersCurrentScore = gameData.player2.score;
      }
      const gamePiecesToTest = gameData.pieces;
      gamePiecesToTest[position] = piece;
      let winner = "";
      let looser = "";
      if (_isTie(gamePiecesToTest)) {
        winner = "tie";
      } else if (_hasWin(gamePiecesToTest, piece)) {
        winner = playerId;
        looser = nextPlayer;
      }
      const gameUpdate = {
        currentPlayer: nextPlayer,
        [pieceUpdateKey]: piece,

      };
      if (winner !== "") {
        gameUpdate.winner = winner;
      }
      if (winner !== "" && winner !== "tie") {
        gameUpdate[scoreUpdateKey] = playersCurrentScore + 1;
      }
      console.log("game update");
      console.log(gameUpdate);
      await admin.firestore().collection("games")
          .doc(gameId).update(gameUpdate);
      console.log(pieceUpdateKey);
      console.log("Successfully played piece!");
      if (winner !== "" && winner !== "tie") {
        console.log(winner);
        console.log(looser);
        await Promise.all([
          updatePointTransaction(winner, true),
          updatePointTransaction(looser, false),
        ]);
        console.log("Score has been updated sucessfully");
      }
      return response.send(true);
    } else {
      return response.send("Not your turn");
    }
  } catch (err) {
    console.log("Error playing piece:", err);
    return response.send(false);
  }
});

exports.replayGame = functions.https.onRequest(async (request, response) => {
  try {
    const gameId = request.query.gameId;
    const playerId = request.query.playerId;
    const player1FcmToken = request.query.player1FcmToken;
    const player2FcmToken = request.query.player2FcmToken;
    const game = await admin.firestore().collection("games").doc(gameId).get();
    if (game.exists) {
      const gameData = game.data();
      if (gameData.winner !== "" &&
                (gameData.player1.user.id !== playerId || gameData.player2.
                    user.id !== playerId)) {
        await admin.firestore().collection("games").doc(gameId).update({
          winner: "",
          pieces: {
            0: "",
            1: "",
            2: "",
            3: "",
            4: "",
            5: "",
            6: "",
            7: "",
            8: "",
          },
        });
        console.log("successfully updated the content");
        const message = {
          data: {
            notificationType: "replayGame",
          },
          // notification: {
          //     title: 'replay',
          //     body: `replay current game`
          // }

        };
        await admin.messaging()
            .sendToDevice([player1FcmToken, player2FcmToken], message);
        console.log("sent to gameId"+ gameId);
        return response.send(true);
      } else {
        return response.status(403).send(false);
      }
    } else {
      console.log("not permitted");
      return response.status(404).send(false);
    }
  } catch (err) {
    console.log("error during replay", err);
    return response.status(500).send(false);
  }
});

exports.cancelGame = functions.https.onRequest(async (request, response) => {
  try {
    const gameId = request.query.gameId;
    const playerId = request.query.playerId;
    const player1FcmToken = request.query.player1FcmToken;
    const player2FcmToken = request.query.player2FcmToken;

    const game = await admin.firestore().collection("games").doc(gameId).get();
    if (game.exists) {
      const gameData = game.data();
      const player1 = gameData.player1;
      const player2 = gameData.player2;

      if (/* gameData.winner !== '' &&*/
        (player1.user.id !== playerId || player2.user.id !== playerId)) {
        console.log(gameData);
        // return Promise.all([gameData.player1, gameData.player2, ]);
        await admin.firestore().collection("games").doc(gameId).delete();
        const message = {
          data: {
            notificationType: "gameEnd",
          },

          notification: {
            title: "Game ended",
            body:
                "Your game( ${player1.user.name}vs${player2.user.name}) ended",
          },
        };
        await Promise.all([
          admin.messaging().sendToDevice([player1FcmToken,
            player2FcmToken], message),
          _changeUserState(player1.user.id, "available"),
          _changeUserState(player2.user.id, "available"),
          _changeGamePlayersState(player1.user.id,
              player2.user.id, "available"),
        ]);

        console.log("successfully cancelled");
        return response.send(true);
      } else {
        return response.status(403).send(false);
      }
    } else {
      return response.status(404).send(false);
    }
  } catch (err) {
    console.log("error during game cancel", err);
    return response.status(500).send(false);
  }
});

exports.onUserStatusChanged = functions.
    database.ref("/status/{userId}").onUpdate(
        (change, context) => {
          // Get the data written to Realtime Database
          const eventStatus = change.after.val();
          const usersRef = admin.firestore().collection("/users");

          return usersRef
              .doc(context.params.userId)
              .set({
                currentState: eventStatus.state,
              }, {merge: true});
        });

/**
 * Retrieves a user by Id.
 * @param {String} playerId -  playerId
 * @param {String} wonGame -  wonGame
 * @return {DocumentReference} User object
 * @throws {NotFoundError} When the user is not found.
 */
function updatePointTransaction(playerId, wonGame) {
  const scoreDocRef = admin.firestore().collection("scores").doc(playerId);
  return admin.firestore().runTransaction((transaction) => {
    // This code may get re-run multiple times if there are conflicts.
    return transaction.get(scoreDocRef).then((sfDoc) => {
      if (!sfDoc.exists) {
        return transaction.create(scoreDocRef, {
          wins: (wonGame)? 1 : 0,
          losses: (wonGame)? 0 : 1,
          wonLast: (wonGame)? true : false,
        });
      }

      let updateObject = {};
      if (wonGame) {
        updateObject = {
          wonLast: true,
          wins: sfDoc.data().wins + 1,
        };
      } else {
        updateObject = {
          wonLast: false,
          losses: sfDoc.data().losses + 1,
        };
      }

      return transaction.update(scoreDocRef, updateObject);
    });
  });
}

/**
 * Retrieves a user by Id.
 * @param {String} pieces -  pieces
 * @return {DocumentReference} User object
 * @throws {NotFoundError} When the user is not found.
 */
function _isTie(pieces) {
  for (const key of Object.keys(pieces)) {
    if (pieces[key] === "") {
      console.log("tie false");
      return false;
    }
  }
  return true;
}
/**
 * Retrieves a user by Id.
 * @param {String} pieces -  pieces
 * @param {String} playerPiece -  playerPiece
 * @return {DocumentReference} User object
 * @throws {NotFoundError} When the user is not found.
 */
function _hasWin(pieces, playerPiece) {
  const possibleWins = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  for (let i = 0; i < possibleWins.length; i++) {
    const currentPossibleWin = possibleWins[i];
    // String playerPiece = player.gamePiece.piece;
    if (pieces[currentPossibleWin[0]] === playerPiece &&
      pieces[currentPossibleWin[1]] === playerPiece &&
      pieces[currentPossibleWin[2]] === playerPiece) {
      console.log("win true");
      return true;
    }
  }
  console.log("win false");
  return false;
}
/**
 * Retrieves a user by Id.
 * @param {String} player1Id -  player1Id
 * @param {String} player2Id -  player2Id
 * @param {String} state -  state
 * @return {DocumentReference} User object
 * @throws {NotFoundError} When the user is not found.
 */
async function _changeGamePlayersState(player1Id, player2Id, state) {
  const usersRef = admin.firestore().collection("users");
  await Promise.all([
    usersRef.doc(player1Id).set({active: state}, {merge: true}),
    usersRef.doc(player2Id).set({active: state}, {merge: true}),
  ]);
}
/**
 * Retrieves a user by Id.
 * @param {String} gameId -  gameId
 * @param {String} receiverId -  receiverId
 * @param {String} receiverName -  receiverName
 * @param {String} receiverFcmToken -  receiverFcmToken
 * @param {String} senderId -  senderId
 * @param {String} senderName - senderName
 * @param {String} senderFcmToken - senderFcmToken
 * @return {DocumentReference} User object
 * @throws {NotFoundError} When the user is not found.
 */
function _createGame(gameId, receiverId, receiverName, receiverFcmToken,
    senderId, senderName, senderFcmToken) {
  console.log("messi");
  return admin.firestore().collection("games").doc(gameId).set({
    // The player who sent the challenge is always player1 and will always be X.
    player1: {
      user: {
        id: receiverId,
        name: receiverName,
        fcmToken: receiverFcmToken,
      },
      gamePiece: "X",
      score: 0,
    },
    player2: {
      user: {
        id: senderId,
        name: senderName,
        fcmToken: senderFcmToken,
      },
      gamePiece: "O",
      score: 0,
    },
    winner: "",
    currentPlayer: receiverId,
    pieces: {
      0: "",
      1: "",
      2: "",
      3: "",
      4: "",
      5: "",
      6: "",
      7: "",
      8: "",
    },
  });
}
/**
 * Retrieves a user by Id.
 * @async
 * @method
 * @param {String} userId - User Id
 * @param {String} state - state
 * @return {DocumentReference} User object
 * @throws {NotFoundError} When the user is not found.
 */
function _changeUserState(userId, state) {
  return admin.firestore().collection("users").doc(userId).set({
    currentState: state,
  }, {merge: true});
}
