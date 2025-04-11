# Restaurant Management App

version: 1.0.0 by Rendy Reynaldy A.

## Features
- Authentication using Devise
- MFA or 2FA through Email
- Table Booking by guest or customer (Booking without login for customer)
- Staff Login to dashboard
- Pagination using Kamari
- Staff able to see frequent customers
- Staff able to see today's reservations
- Staff able to bulk upload customers data with CSV file

## Notes
- CSV Example file:
```
name,email,phone,gender
Alice Johnson,alice.johnson@example.com,555-1234,Female
```


## Tech Used
- [Ruby on Rails](https://rubyonrails.org/) version 8.0.2
- Ruby version 3.2.8
- SQLite
- Stimulus
- Sidekiq
- TailwindCSS
- Kaminari
- Devise
- Rubocop


## Installation
- Download or clone this repository
- Go to project root directory & run this command for installing dependencies:
```sh
bundle install
```
- run this command to migrate database:
```sh
rails db:migrate
rails db:seed
```
- after migration successfull, run this command to run the server in your local machine:
```sh
./bin/dev
```
- By default the url will be: <code>localhost:3000</code>

## Postman Collection
- [Link to Postman Collection](https://www.postman.com/rendy-personal-profile/workspace/rendy-public-api/collection/14027289-a871e25c-359b-4d40-acac-e197df215acd?action=share&creator=14027289)
