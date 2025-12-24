# Clear existing data
puts "Cleaning database..."
Enrollment.destroy_all
Batch.destroy_all
Course.destroy_all
User.destroy_all
School.destroy_all

puts "Creating Super Admin..."
User.create!(
  email: "admin@konnector.com",
  password: "password",
  password_confirmation: "password",
  role: :admin
)

puts "Creating Schools..."
school1 = School.create!(
  name: "Saint Mary's Convent School",
  address: "123 VIP Road, City Center"
)

school2 = School.create!(
  name: "Global International School",
  address: "456 Tech Park Avenue, Tech City"
)

puts "Creating School Admins..."
User.create!(
  email: "principal@convent.com",
  password: "password",
  password_confirmation: "password",
  role: :school_admin,
  school: school1
)

User.create!(
  email: "director@global.com",
  password: "password",
  password_confirmation: "password",
  role: :school_admin,
  school: school2
)

puts "Creating Courses..."
# Convent Courses
english_course = school1.courses.create!(
  name: "English Literature",
  description: "Advanced English Literature and Grammar"
)

history_course = school1.courses.create!(
  name: "World History",
  description: "Comprehensive study of modern history"
)

# Global Courses
cs_course = school2.courses.create!(
  name: "Computer Science",
  description: "Programming fundamentals and algorithms"
)

robotics_course = school2.courses.create!(
  name: "Robotics",
  description: "Building and programming autonomous robots"
)

puts "Creating Batches..."
# Convent Batches
english_batch_a = english_course.batches.create!(
  name: "English Batch A (Morning)",
  start_date: Date.today,
  end_date: Date.today + 6.months
)

history_batch_2024 = history_course.batches.create!(
  name: "History Batch 2024",
  start_date: Date.today,
  end_date: Date.today + 1.year
)

# Global Batches
cs_batch_alpha = cs_course.batches.create!(
  name: "CS Alpha Batch",
  start_date: Date.today,
  end_date: Date.today + 4.months
)

puts "Creating Students..."
# Convent Students
rob = User.create!(
  email: "rob@convent.com",
  password: "password",
  password_confirmation: "password",
  role: :student,
  school: school1
)

tom = User.create!(
  email: "tom@convent.com",
  password: "password",
  password_confirmation: "password",
  role: :student,
  school: school1
)

sarah = User.create!(
  email: "sarah@convent.com",
  password: "password",
  password_confirmation: "password",
  role: :student,
  school: school1
)

# Global Students
mike = User.create!(
  email: "mike@global.com",
  password: "password",
  password_confirmation: "password",
  role: :student,
  school: school2
)

puts "Enrolling Students..."
# Enroll Rob in English (Approved)
Enrollment.create!(
  user: rob,
  batch: english_batch_a,
  status: :approved
)

# Enroll Tom in English (Pending)
Enrollment.create!(
  user: tom,
  batch: english_batch_a,
  status: :pending
)

# Enroll Sarah in History (Approved)
Enrollment.create!(
  user: sarah,
  batch: history_batch_2024,
  status: :approved
)

# Enroll Mike in CS (Approved)
Enrollment.create!(
  user: mike,
  batch: cs_batch_alpha,
  status: :approved
)

puts "Seeding completed successfully!"
puts "----------------------------------------------------------------"
puts "Super Admin:   admin@konnector.com / password"
puts "School Admin:  principal@convent.com / password"
puts "Student (Rob): rob@convent.com / password"
puts "Student (Tom): tom@convent.com / password"
puts "----------------------------------------------------------------"
