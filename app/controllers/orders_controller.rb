require_relative "../views/meal_view"
require_relative "../views/customer_view"
require_relative "../views/employee_view"
require_relative "../views/order_view"

class OrdersController

  def initialize(meal_repository, customer_repository, employee_repository, order_repository)
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    @order_repository = order_repository
    @meal_view = MealView.new
    @customer_view = CustomerView.new
    @employee_view = EmployeeView.new
    @order_view = OrderView.new
  end

  def add
    meal = ask_for_meal
    customer = ask_for_customer
    employee = ask_for_employee
    new_order = Order.new(meal: meal, customer: customer, employee: employee)
    @order_repository.create(new_order)
  end

  def list_my_orders(current_user)
    orders = @order_repository.my_undelivered_orders(current_user)
    @order_view.display_orders(orders)
  end

  def list_undelivered_orders
    @order_view.display_orders(@order_repository.undelivered_orders)
  end

  def mark_as_delivered(current_user)
    # display undelivered orders
    orders = @order_repository.my_undelivered_orders(current_user)
    @order_view.display_orders(orders)
    # ask which one to mark as delivered
    index = @order_view.ask_for(:index).to_i
    # find the order in the array of undelivered orders
    order = orders[index - 1]
    # mark order as delivered
    order.deliver!

    @order_repository.add(order)
  end

  def ask_for_meal
    # get all the meals from the repo
    meals = @meal_repository.all
    # display all meals listed by the index
    @meal_view.display_meals(meals)
    # ask the user for the index of the meal
    index = @meal_view.ask_for(:index).to_i
    # fecth the right meal from the meals array
    meals[index - 1]
  end

  def ask_for_customer
    customers = @customer_repository.all
    @customer_view.display_customers(customers)
    index = @customer_view.ask_for(:index).to_i
    customers[index - 1]
  end

  def ask_for_employee
    employees = @employee_repository.all_riders
    @employee_view.display_employees(employees)
    index = @employee_view.ask_for(:index).to_i
    employees[index - 1]
  end

end
