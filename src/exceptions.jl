struct BadRequestException <: Exception
  message::String
  info::String
  code::Int
  ex::Union{Nothing,Exception}
end

BadRequestException(message::String) = BadRequestException(message, "", 400, nothing)
BadRequestException(message::String, code::Int) = BadRequestException(message, "", code, nothing)
BadRequestException(message::String, info::String, code::Int) = BadRequestException(message, info, code, nothing)
Base.show(io::IO, ex::BadRequestException) = print(io, "BadRequestException: $(ex.code) - $(ex.info) - $(ex.message)")

function bad_request_exception(message)
    html(message, status = 400)
end
