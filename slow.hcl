group "default" {
	targets = [
		"pkg00", "pkg01", "pkg02", "pkg03", "pkg04", "pkg05", "pkg06", "pkg07", "pkg08", "pkg09",
		"pkg10", "pkg11", "pkg12", "pkg13", "pkg14", "pkg15", "pkg16", "pkg17", "pkg18", "pkg19",
		"pkg20", "pkg21", "pkg22", "pkg23", "pkg24", "pkg25", "pkg26", "pkg27", "pkg28", "pkg29",
		"pkg30", "pkg31", "pkg32", "pkg33", "pkg34", "pkg35", "pkg36", "pkg37", "pkg38", "pkg39",
	]
}

variable "BASE" {
  default = "."
}

target "_common" {
	dockerfile = "pkg1/Dockerfile"
	contexts = {
		"base" = "${BASE}"
	}
}

target "base" {
	dockerfile-inline = <<EOT
FROM scratch
COPY . .
EOT
}

target "pkg00" { inherits = ["_common"] }
target "pkg01" { inherits = ["_common"] }
target "pkg02" { inherits = ["_common"] }
target "pkg03" { inherits = ["_common"] }
target "pkg04" { inherits = ["_common"] }
target "pkg05" { inherits = ["_common"] }
target "pkg06" { inherits = ["_common"] }
target "pkg07" { inherits = ["_common"] }
target "pkg08" { inherits = ["_common"] }
target "pkg09" { inherits = ["_common"] }

target "pkg10" { inherits = ["_common"] }
target "pkg11" { inherits = ["_common"] }
target "pkg12" { inherits = ["_common"] }
target "pkg13" { inherits = ["_common"] }
target "pkg14" { inherits = ["_common"] }
target "pkg15" { inherits = ["_common"] }
target "pkg16" { inherits = ["_common"] }
target "pkg17" { inherits = ["_common"] }
target "pkg18" { inherits = ["_common"] }
target "pkg19" { inherits = ["_common"] }

target "pkg20" { inherits = ["_common"] }
target "pkg21" { inherits = ["_common"] }
target "pkg22" { inherits = ["_common"] }
target "pkg23" { inherits = ["_common"] }
target "pkg24" { inherits = ["_common"] }
target "pkg25" { inherits = ["_common"] }
target "pkg26" { inherits = ["_common"] }
target "pkg27" { inherits = ["_common"] }
target "pkg28" { inherits = ["_common"] }
target "pkg29" { inherits = ["_common"] }

target "pkg30" { inherits = ["_common"] }
target "pkg31" { inherits = ["_common"] }
target "pkg32" { inherits = ["_common"] }
target "pkg33" { inherits = ["_common"] }
target "pkg34" { inherits = ["_common"] }
target "pkg35" { inherits = ["_common"] }
target "pkg36" { inherits = ["_common"] }
target "pkg37" { inherits = ["_common"] }
target "pkg38" { inherits = ["_common"] }
target "pkg39" { inherits = ["_common"] }
