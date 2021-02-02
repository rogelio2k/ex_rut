defmodule ExRutTest do
  use ExUnit.Case
  doctest ExRut

  test "ruts as numbers" do
    assert ExRut.valid?(77666354) == true
    assert ExRut.valid?(142508028) == true
  end

  test "ruts as strings (no format)" do
    assert ExRut.valid?("77666354") == true
    assert ExRut.valid?("142508028") == true
  end

  test "ruts as strings (simple format)" do
    assert ExRut.valid?("7766635-4") == true
    assert ExRut.valid?("14250802-8") == true
  end

  test "ruts as strings (full format)" do
    assert ExRut.valid?("7.766.635-4") == true
    assert ExRut.valid?("7,766,635-4") == true
    assert ExRut.valid?("14.250.802-8") == true
    assert ExRut.valid?("14,250,802-8") == true
  end

  test "ruts as strings (ending with k)" do
    assert ExRut.valid?("8925647k") == true
    assert ExRut.valid?("8925647-k") == true
    assert ExRut.valid?("8.925.647-k") == true
    assert ExRut.valid?("8,925,647-k") == true
    assert ExRut.valid?("19979163k") == true
    assert ExRut.valid?("19979163-k") == true
    assert ExRut.valid?("19.979.163-k") == true
    assert ExRut.valid?("19,979,163-k") == true
  end

  test "ruts as strings (ending with 0)" do
    assert ExRut.valid?(85699660) == true
    assert ExRut.valid?("85699660") == true
    assert ExRut.valid?("8569966-0") == true
    assert ExRut.valid?("8.569.966-0") == true
    assert ExRut.valid?("8,569,966-0") == true
    assert ExRut.valid?(118435060) == true
    assert ExRut.valid?("118435060") == true
    assert ExRut.valid?("11843506-0") == true
    assert ExRut.valid?("11.843.506-0") == true
    assert ExRut.valid?("11,843,506-0") == true
  end

  test "calculate dv" do
    assert ExRut.calculate_dv(7766635) == {:ok, "4"}
    assert ExRut.calculate_dv("7766635") == {:ok, "4"}
    assert ExRut.calculate_dv("7.766.635") == {:ok, "4"}
    assert ExRut.calculate_dv("7,766,635") == {:ok, "4"}
  end

  test "calculate dv (bang!)" do
    assert ExRut.calculate_dv!(7766635) == "4"
    assert ExRut.calculate_dv!("7766635") == "4"
    assert ExRut.calculate_dv!("7.766.635") == "4"
    assert ExRut.calculate_dv!("7,766,635") == "4"
  end

  test "fails to calculate_dv" do
    assert_raise  RuntimeError, "Invalid Value", fn ->
      ExRut.calculate_dv!("19979163a")
    end
    assert ExRut.calculate_dv("19979163a") == {:error, :invalid_value}
  end

  test "format ruts (default)" do
    assert ExRut.format(85699660) == {:ok, "8.569.966-0"}
    assert ExRut.format("85699660") == {:ok, "8.569.966-0"}
    assert ExRut.format("8569966-0") == {:ok, "8.569.966-0"}
    assert ExRut.format("8.569.966-0") == {:ok, "8.569.966-0"}
    assert ExRut.format(118435060) == {:ok, "11.843.506-0"}
    assert ExRut.format("118435060") == {:ok, "11.843.506-0"}
    assert ExRut.format("11843506-0") == {:ok, "11.843.506-0"}
    assert ExRut.format("11.843.506-0") == {:ok, "11.843.506-0"}
    assert ExRut.format("19979163-k") == {:ok, "19.979.163-k"}
    assert ExRut.format("19.979.163-k") == {:ok, "19.979.163-k"}
    assert ExRut.format("19,979,163-k") == {:ok, "19.979.163-k"}
  end

  test "format ruts (show_dv: false)" do
    assert ExRut.format(85699660, show_dv: false) == {:ok, "8.569.966"}
    assert ExRut.format("85699660", show_dv: false) == {:ok, "8.569.966"}
    assert ExRut.format("8569966-0", show_dv: false) == {:ok, "8.569.966"}
    assert ExRut.format("8.569.966-0", show_dv: false) == {:ok, "8.569.966"}
    assert ExRut.format(118435060, show_dv: false) == {:ok, "11.843.506"}
    assert ExRut.format("118435060", show_dv: false) == {:ok, "11.843.506"}
    assert ExRut.format("11843506-0", show_dv: false) == {:ok, "11.843.506"}
    assert ExRut.format("11.843.506-0", show_dv: false) == {:ok, "11.843.506"}
    assert ExRut.format("19979163-k", show_dv: false) == {:ok, "19.979.163"}
    assert ExRut.format("19.979.163-k", show_dv: false) == {:ok, "19.979.163"}
    assert ExRut.format("19,979,163-k", show_dv: false) == {:ok, "19.979.163"}
  end

  test "format ruts (delimiter: ',')" do
    assert ExRut.format(85699660, delimiter: ",") == {:ok, "8,569,966-0"}
    assert ExRut.format("85699660", delimiter: ",") == {:ok, "8,569,966-0"}
    assert ExRut.format("8569966-0", delimiter: ",") == {:ok, "8,569,966-0"}
    assert ExRut.format("8.569.966-0", delimiter: ",") == {:ok, "8,569,966-0"}
    assert ExRut.format("8,569,966-0", delimiter: ",") == {:ok, "8,569,966-0"}
    assert ExRut.format(118435060, delimiter: ",") == {:ok, "11,843,506-0"}
    assert ExRut.format("118435060", delimiter: ",") == {:ok, "11,843,506-0"}
    assert ExRut.format("11843506-0", delimiter: ",") == {:ok, "11,843,506-0"}
    assert ExRut.format("11.843.506-0", delimiter: ",") == {:ok, "11,843,506-0"}
    assert ExRut.format("11,843,506-0", delimiter: ",") == {:ok, "11,843,506-0"}
    assert ExRut.format("19979163-k", delimiter: ",") == {:ok, "19,979,163-k"}
    assert ExRut.format("19.979.163-k", delimiter: ",") == {:ok, "19,979,163-k"}
    assert ExRut.format("19,979,163-k", delimiter: ",") == {:ok, "19,979,163-k"}
  end

  test "format ruts (delimiter: ',', show_dv: false)" do
    assert ExRut.format(85699660, delimiter: ",", show_dv: false) == {:ok, "8,569,966"}
    assert ExRut.format("85699660", delimiter: ",", show_dv: false) == {:ok, "8,569,966"}
    assert ExRut.format("8569966-0", delimiter: ",", show_dv: false) == {:ok, "8,569,966"}
    assert ExRut.format("8.569.966-0", delimiter: ",", show_dv: false) == {:ok, "8,569,966"}
    assert ExRut.format("8,569,966-0", delimiter: ",", show_dv: false) == {:ok, "8,569,966"}
    assert ExRut.format(118435060, delimiter: ",", show_dv: false) == {:ok, "11,843,506"}
    assert ExRut.format("118435060", delimiter: ",", show_dv: false) == {:ok, "11,843,506"}
    assert ExRut.format("11843506-0", delimiter: ",", show_dv: false) == {:ok, "11,843,506"}
    assert ExRut.format("11.843.506-0", delimiter: ",", show_dv: false) == {:ok, "11,843,506"}
    assert ExRut.format("11,843,506-0", delimiter: ",", show_dv: false) == {:ok, "11,843,506"}
    assert ExRut.format("19979163-k", delimiter: ",", show_dv: false) == {:ok, "19,979,163"}
    assert ExRut.format("19.979.163-k", delimiter: ",", show_dv: false) == {:ok, "19,979,163"}
    assert ExRut.format("19,979,163-k", delimiter: ",", show_dv: false) == {:ok, "19,979,163"}
  end

  test "format ruts (bang!)" do
    assert ExRut.format!(85699660) == "8.569.966-0"
    assert ExRut.format!("85699660") == "8.569.966-0"
    assert ExRut.format!("8569966-0") == "8.569.966-0"
    assert ExRut.format!("8.569.966-0") == "8.569.966-0"
    assert ExRut.format!(118435060) == "11.843.506-0"
    assert ExRut.format!("118435060") == "11.843.506-0"
    assert ExRut.format!("11843506-0") == "11.843.506-0"
    assert ExRut.format!("11.843.506-0") == "11.843.506-0"
    assert ExRut.format!("19979163-k") == "19.979.163-k"
    assert ExRut.format!("19.979.163-k") == "19.979.163-k"
    assert ExRut.format!("19,979,163-k") == "19.979.163-k"
  end

  test "fails to format" do
    assert_raise  RuntimeError, "Invalid Value", fn ->
      ExRut.format!("19979163-1")
    end
    assert ExRut.format("19979163-1") == {:error, :invalid_value}
  end

end
