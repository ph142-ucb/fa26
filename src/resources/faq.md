---
layout: page
title: Datahub FAQ
nav_exclude: true
description: Datahub FAQs, Common Errors, Debugging Tips/Tricks, 
---

# FAQs & Common Errors
{: .no-toc}

<details open markdown="block">
  <summary>
    On This Page:
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

<hr>

## Datahub FAQ

Q: What is Datahub?

> Datahub is an online computational environment open to all UC Berkeley students and faculty. Each individual has their own independent Datahub server, which allows you to work on projects without having to worry about taking up local storage space or being limited by your computers specifications. In a more pedagogical context, it allows course staff to set up packages and libraries that are unique to each class. 

> As this class is under the UC Berkeley Public Health department, we will be using the [Public Health Hub](https://publichealth.datahub.berkeley.edu/hub/login?next=%2Fhub%2Fuser-redirect%2Fgit-pull%3Frepo%3Dhttps%253A%252F%252Fgithub.com%252Fph142-ucb%252Fph142-fa26%26urlpath%3Drstudio%252F%26branch%3Dmain). The Public Health Datahub automatically configured to run RStudio (instead of Jupyter Notebook, which you might be familiar with if you have taken other courses like Data 8).

Q: How do I access Datahub?

> You may access Datahub by clicking on the [Datahub](https://publichealth.datahub.berkeley.edu/hub/login?next=%2Fhub%2Fuser-redirect%2Fgit-pull%3Frepo%3Dhttps%253A%252F%252Fgithub.com%252Fph142-ucb%252Fph142-fa26%26urlpath%3Drstudio%252F%26branch%3Dmain) link that is located on the sidebar of the page. The Datahub link on the side and all the links on the course schedule are specially made to retrieve any new assignments that we release. Therefore, **it is important that you click on one of these links whenever you want to access Datahub**. At the end of the semester, these links will be converted back to regular datahub links.

Q: Can I use a local version of RStudio instead of Datahub?

> You definitely can! However, **it is your responsibility to retrieve all the assignments when they are released and submit them on Gradescope (both the Rmd and the knitted PDF) once you are finished**. Since your local computer might not have Python3 installed, the `turn_in.py` script to submit the labs may not be working properly. 

Q: How long do I have access to Datahub?

> As long as your Berkeley account exists! Just be aware that if you are inactive on Datahub for a while (longer than a semester), your files might be archived by the Datahub team. If you would like your files back, simply follow the directions on the screen and submit a new [Issue](https://github.com/berkeley-dsep-infra/datahub/issues/new?assignees=felder&labels=support&template=data_archival_request.yml) to request for your files back. If you don't have one already, you might need to create a GitHub account to make the request.

<hr>

## Debugging FAQ

Q: What is debugging?

> To start, let's define a **bug** in the context of coding. A bug in your code simply refers to **an error or something that doesn't go the way that you intended**. This can happen for a variety of reasons, big (e.g. something in the logic of your code doesn't make sense) or small (e.g. you missed a period or closing parenthesis).

> **Debugging**, therefore, is the **process of eliminating bugs**. On average, programmers (who don't create tests) spend only 25% of their time coding and the remaining 75% of their time debugging, if not more. The amount of time debugging will typically decrease with proper test cases and coverage. However, creating test cases is outside the scope of this class. If you want to learn more about testing in R, we recommend reading [Chapter 12 of <u>R Packages</u>](https://r-pkgs.org/tests.html), which covers the `test_that` package and the testing workflow.

Q: How do I start to debug?

> As you start working on assignments, you will inevitably encounter a bug (and many more during your coding life!). Here are a few tips on how you can start debugging your code:

> 1. **Read the Error Message** <br> Error messages exists to help programmers understand what went wrong with their code. Try to read through the error message and understand what the issue was, where the issue occurred, and what could be done to solve it. <br>
> 2. **Google is Your Best Friend** <br> If you are unable to understand why the error message is being caused, you can just simply Google it! Most likely, other programmers have encountered the same issue as you have and have posted on online forum posts such as [Stack Overflow](https://stackoverflow.com/) and [RStudio Support](https://support.rstudio.com/hc/en-us). Make sure to read through the answers carefully in order to understand why your code is working. <br> <br> We also highly recommend you don't copy-paste code from these posts -- not only is it a violation of academic integrity to blatently copy-paste code without attribution, but also it is a better learning experience if you analyze the syntax/structure of the code and type it out for yourself. <br>
> 3. **Brute Force Method: Comment and Run** <br> If you aren't sure where the error is in your code, you can comment out a line (or multiple) at a time and run the code. If you get the same error, keep repeating until the error disappears. The error can be found in the line(s) of code you most recently commented out. This method can get tedious if you have many lines of code, hence it being labeled 'Brute Force'.
<hr>

## Common Datahub Issues/Errors

### Common Error #1: My New Files Aren't Showing Up On Datahub
{: .no_toc }

This is most likely due to one of two things:

1. You're not clicking on the 'Datahub' link on the course website to access Datahub. You won't be able to get any of the new files if you saved the 'publichealth.datahub.berkeley.edu' link!
2. We haven't uploaded the assignment onto Datahub yet (if you believe this to be a mistake, please let the course staff know!)


<br>

### Common Error #2: File Listing Error - `Status Code 403 Returned`
{: .no_toc }

Just refresh your page. Make sure to periodically save your work to avoid losing any progress!

<br>

### Common Error #3: `Error command '['git', '-c' ...]' returned non-zero exit status 128`
{: .no_toc }

1. At the same page where you're getting the error, click on 'Control Panel' located on the top banner of the page.
2. Click on 'My Server'
3. Go to the *terminal* and type `cd; cd ph142-fa26`
4. Type the following into the terminal and press enter after each line of code:
- `git config --global user.email nbgitpuller@nbgitpuller.link`
- `git config --global user.name nbgitpuller`
- `git clean -f`
- `git commit -m "merge conflict"`
5. Go onto the course website and click on the Datahub link. The fix has worked if you're able to access Datahub with no problems.

> _Note: You might lose some of your progress if you have unsaved work. Make sure to periodically save your files!_

<hr>

## Common Knitting Errors

### Common Error #1: `Package inputenc Error: Unicode character _______ not set up...`
{: .no_toc}

The 'Markdown' part of Rmd uses a package called `tinytex` in order to 'beautify' the text that we're writing. `tinytex` allows us to use LaTeX equations as a way to make cleaner math equations on our knitted PDFs.

More often than not, students will copy a character from a PDF that isn't recognized by `tinytex`, hence causing this error. The character in question will show in the error message in the underlined part.

To fix:
1. Copy the unrecognized character (by itself; don't copy the (U + 0000) code next to it).
2. Press `Ctrl + F` (or `Cmd + F` if on Mac) to bring up the Find feature.
3. Paste the unrecognized character into the field and find its location in the Rmd.
4. Remove the character, or replace it with something more LaTeX friendly (e.g. for the 'greater than or equals to' symbol, you can replace with `$\geq$`)

> _Note: If you want to find a particular character covered by LaTeX, either search on Google or refer to this [List of LaTeX Mathematical Symbols](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols)._

### Common Error #2: `Error in parse_block... Duplicate chunk label '_____'`
{: .no_toc}

Recall that the first line of a R chunk in an Rmd takes the following format:

```r
```{r <chunk-name>, <chunk-parameters>}
```

- `<chunk-name>`: A unique name for that R chunk.
- `<chunk-parameters>`: Additional options independent to that chunk when knitting.

This error detects two R chunks with the same name, the name being in the underlined portion of the error message. To fix, simply find one of the two R chunks with the duplicate name and change it to something else.

<hr>
