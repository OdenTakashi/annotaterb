# frozen_string_literal: true

require "integration_spec_helper"

RSpec.describe "Annotate collapsed models", type: "aruba" do
  let(:models_dir) { "app/models" }
  let(:command_timeout_seconds) { 10 }

  it "annotates them correctly" do
    reset_database
    run_migrations

    rails8_path = File.join(::Aruba.config.root_directory, "spec/templates/rails8/#{ENV["DATABASE_ADAPTER"]}", "test_child_default.rb")
    warn "[template-debug] RAILS_VERSION=#{ENV["RAILS_VERSION"].inspect}"
    warn "[template-debug] DATABASE_ADAPTER=#{ENV["DATABASE_ADAPTER"].inspect}"
    warn "[template-debug] root_directory=#{::Aruba.config.root_directory.inspect}"
    warn "[template-debug] rails8_path=#{rails8_path} exist=#{File.exist?(rails8_path)}"
    warn "[template-debug] model_template=#{model_template("test_child_default.rb")}"

    expected_test_model = read_file(model_template("test_child_default.rb"))

    original_test_model = read_file(dummyapp_model("test_child_default.rb"))

    expect(expected_test_model).not_to eq(original_test_model)

    _cmd = run_command_and_stop("bundle exec annotaterb models", fail_on_error: true, exit_timeout: command_timeout_seconds)

    annotated_test_model = read_file(dummyapp_model("test_child_default.rb"))

    expect(last_command_started).to be_successfully_executed
    expect(expected_test_model).to eq(annotated_test_model)
  end
end
