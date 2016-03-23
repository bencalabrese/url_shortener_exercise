class Enrollment < ActiveRecord::Base
  belongs_to :user,
    foreign_key: :student_id,
    primary_key: :id,
    class_name: :User

  belongs_to :course,
    foreign_key: :course_id,
    primary_key: :id,
    class_name: :Course
end
