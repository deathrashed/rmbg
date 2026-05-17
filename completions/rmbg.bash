_rmbg() {
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  case "${prev}" in
    -p|--prefix|-s|--suffix|-f|--fuzz|-b|--background|-m|--match)
      COMPREPLY=()
      return 0
      ;;
    -r|--replace|-o|--open|-R|--recursive|-w|--white|-v|--verbose)
      COMPREPLY=()
      return 0
      ;;
  esac

  if [[ "${cur}" == -* ]]; then
    COMPREPLY=($(compgen -W "-p --prefix -s --suffix -r --replace -o --open -f --fuzz -R --recursive -b --background -w --white -m --match -v --verbose -h --help" -- "${cur}"))
    return 0
  fi

  _filedir
  return 0
}

complete -F _rmbg rmbg