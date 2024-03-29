require 'yaml'

class Logger
  def initialize(log)
    @log = File.open(log, 'a')
    @log << "\n|=======================================#{DateTime.now.strftime("%m-%d-%y  %r")}=======================================|\n\n"
  end

  def dirCreated(dirname)
    "Dir #{dirname} created\n"
  end

  def dbTransfer(db)
    "#{db} has been transferred"
  end

  def fileCreated(path)
    "Created #{path}"
  end

  def dirCreateFail(dirname)
    "Failed to created #{dirname}"
  end

  def fileCreateFail(path)
    "Failed to create #{path}"
  end

  def dirNotFound(dirname)
    "Could not locate dir #{dirname}, creating..."
  end

  def getTimestamp
    "[#{Time.new.strftime("%a %b %e %H:%M:%S %Z %Y")}]"
  end

  def insert(text)
    @log << "\n#{text}\n"
  end

  def logFileExistence(filename)
    if File.exist?(filename)
      self.addMessage("success", self.fileCreated(filename))
    else
      self.addMessage("failure", self.fileCreateFail(filename))
    end
  end

  def logDirExistence(dirname)
    if Dir.exist?(dirname)
      self.addMessage("success", self.dirCreated(dirname))
    else
      self.addMessage("failure", self.dirCreateFail(dirname))
    end
  end

  def addMessage(type, message)
    @log << "#{self.getTimestamp}(#{type.upcase}):#{message}\n"
  end
end

class Backup
  def initialize
    @config = YAML.load_file('config/config.yml')
    @logger = Logger.new(@config['log'])
    @outputDir = @config["output-dir"]
    self.checkDirs
    self.getBackup
  end

  def checkDirs
    @config["databases"].each do |database|
      databasePath = "#{@outputDir}/#{database}"
      if not Dir.exist?(@outputDir)
        @logger.addMessage("info", @logger.dirNotFound(@outputDir))

        Dir.mkdir(@outputDir)

        @logger.logDirExistence(@outputDir)
        @logger.addMessage("info", @logger.dirNotFound(databasePath))

        Dir.mkdir(databasePath)

        @logger.logDirExistence(databasePath)
      else
        if not Dir.exist?(databasePath)
          @logger.addMessage("info", @logger.dirNotFound(databasePath))

          Dir.mkdir(databasePath)

          @logger.logDirExistence(databasePath)
        end
      end
    end
  end

  def getBackup
    @config["databases"].each do |database|
      time = DateTime.now.strftime("%m-%d-%y:%H")
      mongodump_out = `ssh -i #{@config['key']} #{@config['host']} mongodump --db #{database}`

      @logger.insert(mongodump_out)
      @logger.addMessage("success", @logger.dbTransfer(database))

      mongotar = `ssh -i #{@config['key']} #{@config['host']} tar -C dump/#{database} -c ./`

      f = File.new("#{@outputDir}/#{database}/#{time}.tar", File::CREAT|File::RDWR )
      f.puts(mongotar)

      @logger.logFileExistence("#{@outputDir}/#{database}/#{time}.tar")
    end
  end
end

Backup.new()