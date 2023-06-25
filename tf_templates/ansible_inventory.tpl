[web-servers]
%{ for hostname in nodes ~}
${hostname}
%{ endfor ~}