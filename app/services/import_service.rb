# ImportService.new( file_names: ["/Users/cbradbury/pacode/cover-story/test/fixtures/files/collection.zip"], delete_files: false)

class ImportService < SimpleDelegator

  def initialize(params) # file_names is array
    super(Collection.new(
      params[:file_names],
      params[:delete_files])
    )
  end

end
