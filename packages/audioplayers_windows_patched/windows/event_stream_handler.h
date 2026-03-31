#include <flutter/encodable_value.h>
#include <flutter/event_channel.h>

#include <functional>
#include <mutex>

using namespace flutter;

template <typename T = EncodableValue>
class EventStreamHandler : public StreamHandler<T> {
 public:
  EventStreamHandler() = default;

  virtual ~EventStreamHandler() = default;

  void SetDispatcher(std::function<void(std::function<void()>)> dispatcher) {
    m_dispatcher = std::move(dispatcher);
  }

  void Success(std::unique_ptr<T> _data) {
    auto data = std::make_shared<T>(std::move(*_data));
    auto emit = [this, data]() {
      std::unique_lock<std::mutex> _ul(m_mtx);
      if (m_sink.get()) {
        m_sink.get()->Success(*data);
      }
    };
    if (m_dispatcher) {
      m_dispatcher(std::move(emit));
    } else {
      emit();
    }
  }

  void Error(const std::string& error_code,
             const std::string& error_message,
             const T& error_details) {
    auto code = error_code;
    auto message = error_message;
    auto details = error_details;
    auto emit = [this, code, message, details]() {
      std::unique_lock<std::mutex> _ul(m_mtx);
      if (m_sink.get()) {
        m_sink.get()->Error(code, message, details);
      }
    };
    if (m_dispatcher) {
      m_dispatcher(std::move(emit));
    } else {
      emit();
    }
  }

 protected:
  std::unique_ptr<StreamHandlerError<T>> OnListenInternal(
      const T* arguments,
      std::unique_ptr<EventSink<T>>&& events) override {
    std::unique_lock<std::mutex> _ul(m_mtx);
    m_sink = std::move(events);
    return nullptr;
  }

  std::unique_ptr<StreamHandlerError<T>> OnCancelInternal(
      const T* arguments) override {
    std::unique_lock<std::mutex> _ul(m_mtx);
    m_sink.release();
    return nullptr;
  }

 private:
  std::mutex m_mtx;
  std::unique_ptr<EventSink<T>> m_sink;
  std::function<void(std::function<void()>)> m_dispatcher;
};
