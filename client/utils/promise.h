#ifndef PROMISE_H
#define PROMISE_H

#include <QObject>
#include <QString>
#include <QTimer>
#include <QNetworkReply>

template<typename T>
class QPromise;

class QNetPromise;



const auto QUEUED_UNIQUE_CONNEXTION = static_cast<Qt::ConnectionType>(Qt::QueuedConnection | Qt::UniqueConnection);

class QObserver: public QObject{
    Q_OBJECT
public:
    QObserver();

    template<typename R>
    QPromise<R>* map(std::function<R()> cb){
        auto p = new QPromise<R>();
        onSuccess([=](){
            p->success(cb());
        });
        onFail([=](QString error){
            p->fail(error);
        });
        return p;
    }

    void onSuccess(std::function<void()> cb);
    void onFail(std::function<void(const QString& error)> cb);
    void onFinished(std::function<void()> cb);

public slots:
    void fail(const QString& error);
    void success();
    QObserver* thenDo(std::function<void()> cb);
    QNetPromise* then(std::function<QNetworkReply*()> cb);

signals:
    void failed(const QString& error);
    void succeed();
    void finished();

protected:
    void finish();
};

class QNetPromise: public QObserver{
    Q_OBJECT
public:
    QNetPromise(QNetworkReply* reply=nullptr);
    void bind(QNetworkReply* reply);
    QNetworkReply* reply() const {return _reply;}

    using QObserver::map;
    template<typename R>
    QPromise<R>* map(std::function<R(QNetworkReply*)> cb){
        auto p = new QPromise<R>();
        onSuccess([=](QNetworkReply* reply){
            p->success(cb(reply));
        });
        onFail([=](QString error){
            p->fail(error);
        });
        return p;
    }

    using QObserver::onSuccess;
    void onSuccess(std::function<void(QNetworkReply* reply)> cb);

    using QObserver::thenDo;
    using QObserver::then;

public slots:
    void success(QNetworkReply* value);
    QObserver* thenDo(std::function<void(QNetworkReply*)>);
        QNetPromise* then(std::function<QNetworkReply*(QNetworkReply*)>);

signals:
    void succeed(QNetworkReply* reply);

private:
    QNetworkReply* _reply=nullptr;
};

template<typename T>
class QPromise: public QObserver{
public:
    QPromise(): QObserver() {}

    using QObserver::map;
    template<typename R>
    QPromise<R>* map(std::function<R(T)> cb){
        auto p = new QPromise<R>();
        onSuccess([=](T value){
            p->success(cb(value));
        });
        onFail([=](QString error){
            p->fail(error);
        });
        return p;
    }

    using QObserver::onSuccess;
    void onSuccess(std::function<void(T)> cb) {
        _successCallbacks.append(cb);
    }

    void success(T value){
        foreach(auto cb, _successCallbacks)
            QTimer::singleShot(0, [cb,value]{cb(value);});
        QObserver::success();
    }

    using QObserver::thenDo;
    QObserver* thenDo(std::function<void(T)> cb){
        auto o = new QObserver();
        onSuccess([o,cb] (T value){
            cb(value);
            o->success();
        });
        onFail([o](QString error){
            o->fail(error);
        });
        return o;
    }

    using QObserver::then;
    QNetPromise* then(std::function<QNetworkReply*(T)> cb){
        auto p = new QNetPromise();
        onSuccess([p,cb] (QNetworkReply* r){
            p->bind(r);
        });
        onFail([p](QString error){
            p->fail(error);
        });
        return p;
    }
private:
    QList<std::function<void(T)>> _successCallbacks;
};

#endif // PROMISE_H
