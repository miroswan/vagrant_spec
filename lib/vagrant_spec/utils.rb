# encoding: UTF-8

module VagrantSpec
  # Utilities
  module Utils
    # return [String]
    def project_root
      File.absolute_path(File.join(File.dirname(__FILE__), '..', '..'))
    end

    # return [String]
    def lib_root
      File.absolute_path(File.join(File.dirname(__FILE__), '..'))
    end

    # return [String]
    def template_dir
      File.absolute_path(File.join(lib_root, 'vagrant_spec', 'templates'))
    end
  end
end
