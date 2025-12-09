# Local Kustomize Overlay for Rancher Desktop

This overlay configures the Claude Ecosystem for local development using Rancher Desktop.

## Features

- **NodePort Services**: Direct access to all services without ingress
- **Reduced Resources**: Lower CPU/memory limits suitable for local development
- **Local Storage**: Uses Rancher Desktop's local-path provisioner
- **Local Registry**: Configured for localhost:5000 registry
- **Debug Configuration**: Enhanced logging and development settings

## Prerequisites

1. **Rancher Desktop** installed and running
2. **kubectl** configured to use Rancher Desktop context
3. **Helm 3.x** for templating charts
4. **Kustomize** (built into kubectl 1.14+)

## Setup

### 1. Generate Base Manifests from Helm

First, template the Helm chart to generate base Kubernetes manifests:

```bash
cd /path/to/ecosystem-coordinator
helm template ecosystem ./helm/ecosystem -f ./helm/ecosystem/values.yaml > ./kustomize/base/resources.yaml
```

### 2. Build Kustomize Overlay

Preview the generated manifests:

```bash
kubectl kustomize ./kustomize/overlays/local
```

### 3. Apply to Cluster

Deploy to Rancher Desktop:

```bash
kubectl apply -k ./kustomize/overlays/local
```

Or use dry-run to test:

```bash
kubectl apply -k ./kustomize/overlays/local --dry-run=client
```

## Service Access

All services are exposed via NodePort for direct access:

| Service | HTTP Port | gRPC Port | URL |
|---------|-----------|-----------|-----|
| Ecosystem Core | 30080 | - | http://localhost:30080 |
| Feature Registry | 30081 | 30091 | http://localhost:30081 |
| Async Runner | 30082 | - | http://localhost:30082 |
| SDLC Workflow | 30083 | 30093 | http://localhost:30083 |
| Test Manager | 30084 | 30094 | http://localhost:30084 |
| Episodic Memory | 30085 | - | http://localhost:30085 |

## Resource Allocation

Local resource limits are reduced for development:

- **Core Services**: 50m CPU / 64-256Mi RAM
- **Async Runner**: 100m CPU / 128-512Mi RAM (higher for task execution)
- **Episodic Memory**: 50m CPU / 128-512Mi RAM (higher for storage)

## Storage

- **Storage Class**: `local-path` (Rancher Desktop default)
- **Persistent Volume**: 10Gi for Episodic Memory
- **Host Path**: `/var/lib/rancher/k3s/storage/ecosystem-memory`

## Configuration

### Environment Variables

All pods include:
- `ENVIRONMENT=local`
- `LOG_LEVEL=DEBUG`
- `PYTHONUNBUFFERED=1`

### ConfigMap

`local-config` provides:
- Environment settings
- Kubernetes provider info
- Debug flags

### Secrets

`local-secrets` contains development credentials (NOT for production):
- PostgreSQL password
- Redis password
- JWT secret

## Customization

### Modify Resource Limits

Edit `resource-limits-patch.yaml` to adjust CPU/memory:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

### Change NodePort Ports

Edit `service-nodeport-patch.yaml` to use different ports:

```yaml
ports:
  - name: http
    port: 8080
    targetPort: 8080
    nodePort: 31080  # Change this
```

### Use Different Image Registry

Edit `image-registry-patch.yaml` or modify `kustomization.yaml`:

```yaml
images:
  - name: ecosystem-core
    newName: docker.io/your-org/ecosystem-core
    newTag: dev
```

## Troubleshooting

### Check Pod Status

```bash
kubectl get pods -n claude-ecosystem-local
```

### View Logs

```bash
kubectl logs -n claude-ecosystem-local -l app.kubernetes.io/name=ecosystem-core
```

### Describe Resources

```bash
kubectl describe deployment -n claude-ecosystem-local ecosystem-core
```

### Validate Kustomize

```bash
kubectl kustomize ./kustomize/overlays/local | kubectl apply --dry-run=client -f -
```

## Cleanup

Remove all resources:

```bash
kubectl delete -k ./kustomize/overlays/local
```

Or delete the namespace:

```bash
kubectl delete namespace claude-ecosystem-local
```

## Development Workflow

1. **Build Images**: Build service images and push to local registry
2. **Update Tags**: Modify `kustomization.yaml` image tags if needed
3. **Apply Changes**: `kubectl apply -k ./kustomize/overlays/local`
4. **Test**: Access services via NodePort URLs
5. **Iterate**: Make changes and reapply

## Notes

- This overlay is for **local development only**
- Uses insecure default credentials
- No TLS/SSL configured
- Single replica for all services
- No horizontal pod autoscaling
- Storage is ephemeral (deleted with namespace)
