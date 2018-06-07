class ProcessHelper
  def self.pid_still_running?(pid)
    Process.kill(0, Integer(pid))
    true
  rescue Errno::ESRCH # No such process
    false
  rescue Errno::EPERM # The process exists, but you dont have permission to send the signal to it.
    true
  end

  def self.read_pid(pid_type)
    pid_file = Rails.root.join('tmp/pids/', "#{pid_type}.pid")
    return nil if !File.exists?(pid_file)
    File.read(pid_file)
  end

  def self.write_pid(pid_type, pid)
    pid_file = Rails.root.join('tmp/pids/', "#{pid_type}.pid")
    f = File.new(pid_file, 'w')
    f.write(pid)
    f.close
  end
end
