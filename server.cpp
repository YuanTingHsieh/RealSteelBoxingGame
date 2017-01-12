#include "server.h"
#include <iostream>
#include <string>

Server::Server(QObject* parent, int portNumber): QObject(parent)
{
  connect(&server, SIGNAL(newConnection()),
    this, SLOT(acceptConnection()));

  server.listen(QHostAddress::Any, portNumber);

  m_clients = 0;
  if (portNumber==7777)
      user=1;
  else
      user=0;
}

Server::~Server()
{
  server.close();
}

void Server::acceptConnection()
{
  client = server.nextPendingConnection();
  m_pClientSocketList.push_back(client);

  connect(client, SIGNAL(readyRead()),
    this, SLOT(startRead()));

  m_clients += 1;

  std::cout << "Accept connections of user "<< user+1 << std::endl;
  //std::cout << "  # of total connections: "<<m_clients<< std::endl;

  connect(client, &QTcpSocket::disconnected, this, &Server::ClientDisconnected);
}

void Server::ClientDisconnected()
{
    // client has disconnected, so remove from list
    QTcpSocket* pClient = static_cast<QTcpSocket*>(QObject::sender());

    m_clients -= 1;
    std::cout << "Remove connections "<< std::endl;
    std::cout << "  # of total connections: "<<m_clients<< std::endl;
    for (int i=0; i<m_pClientSocketList.count(); ++i){
        if (m_pClientSocketList[i]==pClient)
            emit userDisconnected(i);
    }
    m_pClientSocketList.removeOne(pClient);

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
  if (theSignal=="user1 both ready")
  {
      std::cout << "user 1 ready" << std::endl;
      emit userConnected(0);
  }
  else if (theSignal=="user2 both ready")
  {
      std::cout << "user 2 ready" << std::endl;
      emit userConnected(1);
  }

  // game logic
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
