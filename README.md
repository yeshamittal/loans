# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version > 2.7.0

* System dependencies: Install Ruby, SQLite, Rails

* steps to run service:
  * cd loans
  * bin rails/server
  * For any issues - https://guides.rubyonrails.org/getting_started.html

* Database creation - Gets automatically created

* Postman collection of all the APIs is present along side app folder

* Assumptions:
  * User_id and role are received in requests. This is because service is receiving authenticated requests (maybe from Gateway)
  * When admin gets list of requests to approve, showing only pending requests for now. This can be changed based on usecase
  * When customer fetches loan requests, all requests created by him are shown
  * When admin approves a loan request, only then repayment schedules are created. This is to ensure that in case a loan is not approved, we are not creating unnecessary scheduled payments
  * If a customer pays more than schedule amount, there can be 2 scenarios:
        * Reduce terms
        * Reduce amount of each term by keeping terms intact
    * Here, I am keeping terms intact and equally distributing extra amount to remaining schedules
