name := "bar-prefetchers"
version := "0.1"
scalaVersion := "2.13.10"

scalacOptions ++= Seq(
  "-language:reflectiveCalls",
  "-deprecation",
  "-feature"
)

libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.5.2"
