After do |scenario|
  save_and_open_page if scenario.status == :failed
end