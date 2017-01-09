#ifndef SERVER_H
#define SERVER_H

#include <QtNetwork>
#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>

class Server: public QObject {
    Q_OBJECT
public:
    Server(QObject * parent = 0, int portNumer = 8888);
    //int getValue() const { return m_value; }
    ~Server();

public slots:
    //void setValue();
    void acceptConnection();
    void startRead();

signals:
    void punchChanged(int punchType);
    void actionChanged(int actionType);
    //void sideChanged(int sideType);

private:
    int m_value;
    QTcpServer server;
    QTcpSocket* client;
};

#endif // SERVER_H
