use std::path::Path;
use std::fs::File;
use std::io::{BufReader, BufRead};
use std::collections::HashSet;

fn main() {
    let passports: Vec<String> = read_file("./files/day_05_input.txt");
  
    let mut seat_ids: Vec<i32> = vec![];
    for passport in passports.iter() {
        seat_ids.push(decode(&passport[0..7]) * 8 + decode(&passport[7..10]));
    }
    seat_ids.sort();

    let low: i32  =  *seat_ids.first().unwrap();
    let high: i32 = *seat_ids.last().unwrap();
    println!("Part 1: {}", high);

    let all_passes: Vec<i32> = (low..high).collect();
    let missing: Vec<i32> = difference(&all_passes, &seat_ids); // Should only have 1
    println!("Part 2: {}", missing.first().unwrap());
}

pub fn decode(passport: &str) -> i32 {
    let bits:String = passport.chars().map(|c| match c {
        'F' => '0',
        'L' => '0',
        'B' => '1',
        'R' => '1',
        _ => c
    }).collect();
    return i32::from_str_radix(&bits, 2).unwrap();
}

pub fn difference(v1: &Vec<i32>, v2: &Vec<i32>) -> Vec<i32> {
    let s1: HashSet<i32> = v1.iter().cloned().collect();
    let s2: HashSet<i32> = v2.iter().cloned().collect();
    (&s1 - &s2).iter().cloned().collect()
}

pub fn read_file(filename: impl AsRef<Path>) -> Vec<String> {
    let file = File::open(filename).expect("No such file");
    let buf = BufReader::new(file);
    buf.lines()
        .map(|line| line.expect("Could not parse line"))
        .collect()
}
