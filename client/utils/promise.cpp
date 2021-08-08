#include "promise.h"
#include "services/server.h"

QObserver::QObserver(): QObject()
{}

void QObserver::onSuccess(std::function<void ()> cb) {
    QObject::connect(this, &QObserver::succeed, this, cb, QUEUED_UNIQUE_CONNEXTION);
}

void QObserver::onFail(std::function<void (const QString &)> cb) {
    QObject::connect(this, &QObserver::failed, this, cb, QUEUED_UNIQUE_CONNEXTION);
}

void QObserver::onFinished(std::function<void ()> cb) {
    QObject::connect(this, &QObserver::failed, this, cb, QUEUED_UNIQUE_CONNEXTION);
}

void QObserver::fail(const QString &error) {
    emit failed(error);
    finish();
}

void QObserver::success() {
    emit succeed();
    finish();
}

QObserver* QObserver::thenDo(std::function<void ()> cb) {
    auto o = new QObserver();
    onSuccess([o,cb] (){
        cb();
        o->success();
    });
    onFail([o](QString error){
        o->fail(error);
    });
    return o;
}

QNetPromise *QObserver::then(std::function<QNetworkReply *()> cb) {
    auto p = new QNetPromise();
    onSuccess([p,cb] (){
        p->bind(cb());
    });
    onFail([p](QString error){
        p->fail(error);
    });
    return p;
}

void QObserver::finish() {
    emit finished();
    this->deleteLater();
}



QNetPromise::QNetPromise(QNetworkReply *reply): QObserver() {
    if(reply!=nullptr)
        bind(reply);
}

void QNetPromise::bind(QNetworkReply *reply) {
    // Success
    QObject::connect(reply, &QNetworkReply::finished, [this, reply](){
        if(reply->error())
            this->fail(ServerService::formatError(reply));
        else
            this->success(reply);
    });
}

void QNetPromise::onSuccess(std::function<void (QNetworkReply *)> cb){
    QObject::connect(this, &QNetPromise::succeed, this, cb, QUEUED_UNIQUE_CONNEXTION);
}

void QNetPromise::success(QNetworkReply *value) {
    emit succeed(value);
    QObserver::success();
}

QObserver* QNetPromise::thenDo(std::function<void (QNetworkReply *)> cb) {
    auto o = new QObserver();

    onSuccess([o,cb] (QNetworkReply* reply){
        cb(reply);
        o->success();
    });
    onFail([o](QString error){
        o->fail(error);
    });
    return o;
}

QNetPromise *QNetPromise::then(std::function<QNetworkReply* (QNetworkReply* )> cb) {
    auto p = new QNetPromise();
    onSuccess([p,cb] (QNetworkReply* reply){
        p->bind(cb(reply));
    });
    onFail([p](QString error){
        p->fail(error);
    });
    return p;
}
