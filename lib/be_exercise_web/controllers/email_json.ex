defmodule BeExerciseWeb.EmailJSON do
  def show_response(%{response: response}) do
    message =
      response
      |> case do
        {0, _} ->
          "No email sent"

        {total, not_sent} when not_sent > 0 ->
          "#{total - not_sent} email sent, #{not_sent} not sent"

        {total, _} ->
          "#{total} email sent"
      end

    %{data: %{message: message}}
  end
end
