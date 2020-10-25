require 'csv'
require 'date'
require './lib/midilib'
require './code_list'
require './output_midi'

# 読み込みたいcsvファイルをルートディレクトリ以下に置いて、パス名を変更してください
CSV_FILE_NAME = 'sample.csv'
BPM = '120'

seq = MIDI::Sequence.new()
track = MIDI::Track.new(seq)
seq.tracks << track
track.events << MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(BPM.to_i))

csv_file = CSV_FILE_NAME

codes = CSV.read(csv_file).flatten.compact
codes.map.with_index { |code, i| codes[i] = codes[i-1] if code.empty? }

size = 0
codes.each_with_index do |code, i|
	size += 1

	if codes[i+1] != code or size == 4 or codes.size == i + 1
		length = case size
					when 4
						seq.note_to_delta('whole')
					when 3
						seq.note_to_delta('half') + seq.note_to_delta('quarter')
					when 2
						seq.note_to_delta('half')
					when 1
						seq.note_to_delta('quarter')
					end
		CodeList.add_code(code, track, length)

		size = 0
	end
end

OutputMidi.run(seq)
