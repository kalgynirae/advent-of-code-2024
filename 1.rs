use std::collections::HashMap;

fn main() -> () {
    let mut list1: Vec<i32> = Vec::new();
    let mut list2: Vec<i32> = Vec::new();
    for line_result in std::io::stdin().lines() {
        let line = line_result.unwrap();
        let (a_str, b_str) = line.split_once("   ").unwrap();
        list1.push(a_str.parse().unwrap());
        list2.push(b_str.parse().unwrap());
    }
    list1.sort_unstable();
    list2.sort_unstable();
    let difference: i32 = list1.iter().zip(list2).map(|(a, b)| (a - b).abs()).sum();
    println!("Part 1 answer (difference): {difference}");
}
