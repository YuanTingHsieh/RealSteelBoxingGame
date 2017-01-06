#include "server.h"
#include <iostream>

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
  //client->close();
  if (buffer[0]=='L' && buffer[1]=='e' && buffer[2]=='f' && buffer[3]=='t')
  {
      std::cout << "Enter left" << std::endl;
      emit valueChanged(0);
  }
  else
  {
      std::cout << "Enter right" << std::endl;
      emit valueChanged(1);
  }
}

//void Server::setValue() {
//    emit valueChanged();
//}
