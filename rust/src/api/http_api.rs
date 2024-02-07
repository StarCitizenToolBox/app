use std::collections::HashMap;
use hyper::Method;
use crate::http_package;
use crate::http_package::RustHttpResponse;


pub enum MyMethod {
    Options,
    Gets,
    Post,
    Put,
    Delete,
    Head,
    Trace,
    Connect,
    Patch,
}

fn _my_method_to_hyper_method(m: MyMethod) -> Method {
    return match m {
        MyMethod::Options => { Method::OPTIONS }
        MyMethod::Gets => { Method::GET }
        MyMethod::Post => { Method::POST }
        MyMethod::Put => { Method::PUT }
        MyMethod::Delete => { Method::DELETE }
        MyMethod::Head => { Method::HEAD }
        MyMethod::Trace => { Method::TRACE }
        MyMethod::Connect => { Method::CONNECT }
        MyMethod::Patch => { Method::PATCH }
    };
}

pub fn set_default_header(headers: HashMap<String, String>) {
    http_package::set_default_header(headers)
}

pub async fn fetch(method: MyMethod,
                   url: String,
                   headers: Option<HashMap<String, String>>,
                   input_data: Option<Vec<u8>>) -> RustHttpResponse {
    http_package::fetch(_my_method_to_hyper_method(method), url, headers, input_data).await.unwrap()
}