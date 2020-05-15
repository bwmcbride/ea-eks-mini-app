FROM busybox

CMD [ "/bin/sh",  "-c", "while true ; do echo mini-app $(date) ; sleep 10 ; done " ]

ARG image_name
ARG build_date
ARG git_commit_hash

LABEL com.epimorphics.name="$image_name"
LABEL com.epimorphics.created="$build_date"
LABEL com.epimorphics.revision="$git_commit_hash"

