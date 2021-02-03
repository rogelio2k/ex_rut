# ExRut

  An Elixir library to validate and format chilean ID/TAX number ('RUN/RUT')

## Installation

  Add ExRut as a dependency in your `mix.exs` file:

  ```elixir
  def deps do
    [
      {:ex_rut, "~> 0.1.0"}
    ]
  end
  ```

  Next, run `mix deps.get` in your shell to fetch and compile `ExRut`.

  See the [online documentation](http://hexdocs.pm/ex_rut) for more information.

## Usage

### Validating an ID/TAX number (*RUN/RUT*)

  ```elixir
  ExRut.valid?(116334976) # value as integer
  true

  ExRut.valid?("116334976")
  true

  ExRut.valid?("11633497-6")
  true

  ExRut.valid?("11.633.497-4") # invalid
  false

  ExRut.valid?("8953285k")
  true

  ExRut.valid?("8953285-k")
  true

  ExRut.valid?("8.953.285-k")
  true

  ExRut.valid?("8.953.285-1") # invalid
  false
  ```

### Calculating a verification digit (*Digito Verificador*)
  ```elixir
  ExRut.calculate_dv(8953285) # value as integer
  {:ok, "k"}

  ExRut.calculate_dv("8953285")
  {:ok, "k"}

  ExRut.calculate_dv("11633497")
  {:ok, "6"}

  ExRut.calculate_dv("11.633.497")
  {:ok, "6"}

  ExRut.calculate_dv("11.633.xxx")
  {:error, :invalid_value}

  ExRut.calculate_dv!(8953285) # value as integer
  "k"

  ExRut.calculate_dv!("11.633.497")
  "6"

  ExRut.calculate_dv!("11.633.xxx")
  ** (RuntimeError) Invalid Value
  ```

### Formating

  Default format uses `.` as thousands separator and includes the verification digit separated with a `-`

  ```elixir
  ExRut.format(85699660) # value as integer
  {:ok, "8.569.966-0"}

  ExRut.format("85699660")
  {:ok, "8.569.966-0"}

  ExRut.format("8569966-0")
  {:ok, "8.569.966-0"}

  ExRut.format("8.569.966-0")
  {:ok, "8.569.966-0"}

  ExRut.format("8,569,966-0")
  {:ok, "8.569.966-0"}

  ExRut.format("8,569,966-k")
  {:error, :invalid_value}

  ExRut.format!("8,569,966-0")
  "8.569.966-0"

  ExRut.format!("8,569,966-k")
  ** (RuntimeError) Invalid Value
  ```

  The following options are available to modify the default format output:

  - `delimitier`: thousands separator symbol (default: `.`)
  - `show_dv`: toggle on and off the display of the verification number (default: `true`).

  ```elixir
  ExRut.format(85699660, delimiter: ",")
  {:ok, "8,569,966-0"}

  ExRut.format(85699660, delimiter: "")
  {:ok, "8569966-0"}

  ExRut.format(85699660, delimiter: ",", show_dv: false)
  {:ok, "8,569,966"}

  ExRut.format(85699660, show_dv: false)
  {:ok, "8.569.966"}
  ```

## TODO

  - Improve documentation
  - Integrate CI

## License

   Copyright 2021 Bloqzilla SpA

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
