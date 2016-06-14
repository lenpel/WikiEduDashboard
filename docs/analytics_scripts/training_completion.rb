require 'csv'

cohort = Cohort.find_by(slug: 'spring_2016')

# CSV of all assigned training modules for courses in the cohort:
# course slug, training module, due date

courses = cohort.courses
csv_data = []
courses.each do |course|
  course.training_modules.each do |training_module|
    due_date = TrainingModuleDueDateManager.new(course: course, training_module: training_module)
                                           .computed_due_date
    csv_data << [course.slug, training_module.slug, due_date]
  end
end

CSV.open('/home/sage/spring_2016_training_due_dates.csv', 'wb') do |csv|
  csv_data.each do |line|
    csv << line
  end
end

# CSV of all training module progress for students in the cohort:
# username, training module, last slide completed, module completion date

user_csv_data = []
cohort.students.each do |student|
  student.training_modules_users.each do |tmu|
    user_csv_data << [student.username,
                      tmu.training_module.slug,
                      tmu.last_slide_completed,
                      tmu.completed_at]
  end
end

CSV.open('/home/sage/spring_2016_student_training_completion.csv', 'wb') do |csv|
  user_csv_data.each do |line|
    csv << line
  end
end
