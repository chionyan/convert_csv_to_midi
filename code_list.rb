require './lib/midilib'
require 'yaml'

class CodeList
  PATH = './code_list.yml'
  CODE_LIST = YAML.load_file(PATH)['code']

  def self.add_code(code, track, length)
    code_nums = if code.include?('on')
                  code_on_note(code)
                else
                  CODE_LIST[code]
                end

    constitution(code_nums, track, length)
  end

  private

  def self.constitution(code_arr, track, length)
    code_arr.each do |note|
    	track.events << MIDI::NoteOn.new(0, note, 127, 0)
    end

    code_arr.each_with_index do |note, i|
      length = 0 if i != 0
      track.events << MIDI::NoteOff.new(0, note, 127, length)
    end
  end

  def self.code_on_note(code)
    base_code, note = code.split(' on ')
    code_nums = CODE_LIST[base_code]
    note_num = YAML.load_file(PATH)[note.gsub('#', 's').gsub('♭', 'f')]

    p code if note_num.nil?

    while note_num < code_nums.last do
      note_num += 12
    end

    code_nums + [note_num]
  end
end
