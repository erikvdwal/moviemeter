require "moviemeter/version"

require 'xmlrpc/client'

directory = File.expand_path(File.dirname(__FILE__))
require File.join(directory, 'moviemeter', 'client')
require File.join(directory, 'moviemeter', 'movie')
require File.join(directory, 'moviemeter', 'review')
require File.join(directory, 'moviemeter', 'screening')
require File.join(directory, 'moviemeter', 'release')
require File.join(directory, 'moviemeter', 'image')
require File.join(directory, 'moviemeter', 'director')