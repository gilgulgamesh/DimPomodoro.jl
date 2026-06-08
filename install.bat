winget install --name Julia --id 9NJNWW8PVKMN -e -s msstore

julia --project=. -e "using Pkg; Pkg.instantiate()"
