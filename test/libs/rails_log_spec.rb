require 'test_helper'

describe RailsLog do
  describe "default_meta_parser" do
    before(:each) do
      Source.create(filename: "/tmp/mytest",
                    mtime: "2013-11-21 19:21:52.000000",
                    filesize: 3791368
                    )
    end

    it "updates sources entry with default values if block not passed " do
      RequestLogAnalyzerRunner.any_instance.stubs(:parse).returns(true)
      rl = RailsLog.new()
      rl.setup({file_list: ["/tmp/mytest"]})
      rl.parse
      source = Source.find_by(filename: "/tmp/mytest")
      source.file_type.must_equal("rails")

    end
  end
end
