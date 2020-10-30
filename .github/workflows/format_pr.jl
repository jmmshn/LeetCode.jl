name: format-pr

on:
  schedule:
    - cron: '0 0 * * *'
jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        julia-version: [1.3.0]
        julia-arch: [x86]
        os: [ubuntu-latest]
    steps:
      - uses: julia-actions/setup-julia@latest
        with:
          version: ${{ matrix.julia-version }}

      - uses: actions/checkout@v2
      - name: Install JuliaFormatter and format
        run: |
          julia  -e 'import Pkg; Pkg.add("JuliaFormatter")'
          julia  -e 'using JuliaFormatter; format(".", BlueStyle();verbose=true)'
          
      # https://github.com/marketplace/actions/create-pull-request
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v2
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: Format .jl files
          title: 'Automatic JuliaFormatter.jl run'
          branch: auto-juliaformatter-pr
          labels: formatting, automated pr, no changelog
      - name: Check outputs
        run: |
          echo 'Pull Request Number - ${{ env.PULL_REQUEST_NUMBER }}'
          echo 'Pull Request Number - ${{ steps.cpr.outputs.pr_number }}'
