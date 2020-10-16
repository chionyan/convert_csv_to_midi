class OutputMidi
  def self.run(seq)
    File.open(directory + filename, 'wb') { |file| seq.write(file) }
  end

  private

  def self.directory
    '/Users/ariariarissa/Downloads/'
  end

  def self.filename
    nowTime = DateTime.now
    date = format('%02d', nowTime.year) + format('%02d', nowTime.month) + format('%02d', nowTime.day)
    time = format('%02d', nowTime.hour) + format('%02d', nowTime.minute) + format('%02d', nowTime.second)

    date + time + '_output.mid'
  end
end
