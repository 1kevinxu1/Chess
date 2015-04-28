class Employee

  attr_accessor :salary, :name, :manager, :employees

  def initialize(name, salary, manager = nil)
    @name = name
    @salary = salary
    @manager = manager
    @manager.employees << self if @manager
    @employees = nil
  end

  def bonus(multiplier)
    return (salary * multiplier)
  end

end

class Manager < Employee

  attr_accessor :employees

  def initialize(name, salary, manager = nil, employees = [])
    super(name, salary, manager)
    @employees = employees
  end

  def bonus(multiplier)
    multiplier * (Manager.total_salaries(self) - self.salary)
  end

  def self.total_salaries(current_employee)
    return current_employee.salary unless current_employee.employees

    total_suboord = current_employee.employees.inject(0) do |total, suboord|
      total + Manager.total_salaries(suboord)
    end

    return current_employee.salary + total_suboord
  end


end
