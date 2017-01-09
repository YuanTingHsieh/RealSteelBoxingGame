#include "server.h"
#include <iostream>
#include <string>

Server::Server(QObject* parent, int portNumber): QObject(parent)
{
  connect(&server, SIGNAL(newConnection()),
    this, SLOT(acceptConnection()));

  server.listen(QHostAddress::Any, portNumber);

  m_value = 0;
}

Server::~Server()
{
  server.close();
}

void Server::acceptConnection()
{
  client = server.nextPendingConnection();

  connect(client, SIGNAL(readyRead()),
    this, SLOT(startRead()));
}

void Server::startRead()
{
  char buffer[1024] = {0};
  client->read(buffer, client->bytesAvailable());
  std::cout << buffer << std::endl;
  // "Action=attack"
  // "Action=defense"
  // "Side=right"
  // "Side=middle"
  // "Side=left"
  //client->close();
  std::string theSignal(buffer);
  if (theSignal=="Left")
  {
      std::cout << "Enter left" << std::endl;
      emit punchChanged(0);
  }
  else if (theSignal=="Right")
  {
      std::cout << "Enter right" << std::endl;
      emit punchChanged(1);
  }
  if (theSignal=="Action=defense")
  {
      emit actionChanged(0);
  }
  else if (theSignal=="Action=attack")
  {
      emit actionChanged(1);
  }
  else if (theSignal=="Side=left")
  {
      emit actionChanged(2);
  }
  else if (theSignal=="Side=middle")
  {
      emit actionChanged(3);
  }
  else if (theSignal=="Side=right")
  {
      emit actionChanged(4);
  }
}
