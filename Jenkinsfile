pipeline 
{
    agent {label '!master'}

    stages 
    {
        stage('Clone project')
        {
            steps
            {
                sh(script: """mkdir pythonapp """)
                git url:'https://github.com/asxan/kubernetes-repo.git', branch:'boozshop', folder:'$pwd/pythonapp'
                sh(script: """ 
                ls -la
                cd ..
                pwd """)
            }
        }       
    }
}
