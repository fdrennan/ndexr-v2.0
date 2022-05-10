mod redpul;

use crate::redpul::redpul_pull;
use crate::redpul::redpul_pull_author;
use extendr_api::prelude::*;
use futures::future::join_all;
use tokio;
use tokio::runtime::Builder;

///
/// @export
#[extendr]
pub fn redpul_find(dataset: Robj) -> Robj {
    // BUILD RUNING IN ORDER TO RUN ASYNC FUNCTION
    // Used as an alternative to #[tokio::main] since exporting using #[extendr] already.
    // The trick here is that I am running one async function, but I want to run many.
    let rt = Builder::new_current_thread().enable_all().build().unwrap();

    let response = rt.block_on(async {
        let mut futures = vec![];
        for sr in dataset.as_str_vector().iter().flatten() {
            futures.push(redpul_pull(*sr));
        }
        let results = join_all(futures).await;
        let out: Vec<String> = results.into_iter().flatten().collect();
        out
    });

    response.into_robj()
    // let dv= data_vec.first().unwrap();
    // dv
}

///
/// @export
#[extendr]
pub fn redpul_find_author(dataset: Robj) -> Robj {
    let rt = Builder::new_current_thread().enable_all().build().unwrap();

    let response = rt.block_on(async {
        let mut futures = vec![];
        for sr in dataset.as_str_vector().iter().flatten() {
            futures.push(redpul_pull_author(*sr));
        }
        let results = join_all(futures).await;
        let out: Vec<String> = results.into_iter().flatten().collect();
        out
    });

    response.into_robj()
    // let dv= data_vec.first().unwrap();
    // dv
}


//
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod redpul;
    fn redpul_find;
    fn redpul_find_author;
}
