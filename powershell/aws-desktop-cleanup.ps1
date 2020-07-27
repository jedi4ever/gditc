#AWS Clean up Desktop Items
function clean-aws {
    remove-item -path "c:\Users\Administrator\Desktop\EC2 Feedback.Website"
    Remove-Item -Path "c:\Users\Administrator\Desktop\EC2 Microsoft Windows Guide.website"
}

clean-aws