// This build is not meant to be used standalone.

// Required dependencies injected from chipyard build:
//   - rocketchip

scalaVersion := "2.13.10"

name := "bearly-nearmem"
version := "0.1.0"

val chiselVersion = "3.5.5"

libraryDependencies ++= Seq(
  "edu.berkeley.cs" %% "chisel3" % chiselVersion,
  "edu.berkeley.cs" %% "chiseltest" % "0.5.5" % Test,
)

scalacOptions ++= Seq(
  "-language:reflectiveCalls",
  "-deprecation",
  "-feature",
  "-unchecked",
)

scalacOptions += "-Ywarn-unused"

addCompilerPlugin(
  "edu.berkeley.cs" % "chisel3-plugin" % chiselVersion cross CrossVersion.full
)
