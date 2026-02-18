scripts:
  test:
    cmds:
      - npm run lint
      - npm run build
    desc: Run all tests
      
  format:
    cmds:
      - npx prettier --write .
      - npm run lint --fix
    desc: Format and lint code

dev:
  makefile: Makefile
