using UnityEngine;
using System.Collections;

//Controls the RenderCamera;
[ExecuteInEditMode]
public class SSS_FetchDepth : MonoBehaviour
{
    Camera m_camThis;   //This DepthCamera
    public Material m_matDepth;     //Material with the "RenderDepth"Shader

    void Start()
    {
        m_camThis = GetComponent<Camera>();    //Grab CameraComponent
        m_camThis.depthTextureMode = DepthTextureMode.Depth;   //Set DepthTextureMode
    }

    //Renders the DepthMap to the RenderTexture
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, m_matDepth);
    }
}