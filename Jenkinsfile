pipeline {
    agent {label '!master'}

    stages {
        stage('Clone_project') {
            sh(script: """mkdir pythonapp  && cd pythonapp  """)
            git url:'https://github.com/asxan/kubernetes-repo.git', branch:'boozshop'
            sh(script: """cd .. && pwd """)
        }
    }
}
