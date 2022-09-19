void pongOOCSIHandler(OOCSIEvent event) {
  if (event.has("button")) {
    pong.event(event.getInt("player", -1), event.getInt("button", -1), event.getInt("state", -1));
  }

  if (event.has("request")) {
    int request = event.getInt("request", 0);
    if (request == 0) pong.requestUUID();
  }
  
  if (event.has("register")){
    pong.register(event.getInt("register", -1), event.getString("uuid")); 
  }
}
