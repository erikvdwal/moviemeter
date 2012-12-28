module Moviemeter
	class Image
		attr_reader :type, :width, :height, :filetype, :encoded_contents

		def initialize(values)
			@type = values[0]
			@width = values[1]['width'].to_i
			@height = values[1]['height'].to_i
			@filetype = values[1]['filetype']
			@encoded_contents = values[1]['base64_encoded_contents']
		end
	end
end