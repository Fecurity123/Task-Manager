require 'json'

class TaskManager
  FILE_PATH = 'tasks.json'

  def initialize
    @tasks = load_tasks
  end

  def add_task(description)
    @tasks << { 'description' => description, 'completed' => false }
    save_tasks
  end

  def list_tasks
    @tasks.each_with_index do |task, index|
      status = task['completed'] ? '✓' : '✗'
      puts "#{index + 1}. #{task['description']} [#{status}]"
    end
  end

  def complete_task(index)
    return unless (0...@tasks.size).include?(index)

    @tasks[index]['completed'] = true
    save_tasks
  end

  private

  def load_tasks
    if File.exist?(FILE_PATH)
      JSON.parse(File.read(FILE_PATH))
    else
      []
    end
  end

  def save_tasks
    File.write(FILE_PATH, JSON.pretty_generate(@tasks))
  end
end

def menu
  puts "Менеджер задач"
  puts "1. Добавить задачу"
  puts "2. Показать задачи"
  puts "3. Завершить задачу"
  puts "4. Выйти"
end

task_manager = TaskManager.new

loop do
  menu
  choice = gets.chomp.to_i

  case choice
  when 1
    puts "Введите описание задачи:"
    description = gets.chomp
    task_manager.add_task(description)
  when 2
    task_manager.list_tasks
  when 3
    puts "Введите номер задачи для завершения:"
    index = gets.chomp.to_i - 1
    task_manager.complete_task(index)
  when 4
    puts "До свидания!"
    break
  else
    puts "Неверный выбор. Пожалуйста, попробуйте снова."
  end
end
