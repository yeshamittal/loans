Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/loan_requests", to: "loan_requests#index"

  post "/loan_requests/apply", to: "loan_requests#apply"
  get "/loan_requests/fetch_loan", to: "loan_requests#fetch_loan"
  get "/loan_requests/details", to: "loan_requests#details"
  post "/loan_requests/repay", to: "loan_requests#repay"

  get "/loans_admin/fetch_loans", to: "loans_admin#fetch_loans"
  post "/loans_admin/approve", to: "loans_admin#approve"

end
