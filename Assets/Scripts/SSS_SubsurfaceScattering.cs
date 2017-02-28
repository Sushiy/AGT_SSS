using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

//Passes all necessary SceneData to the Materials 
public class SSS_SubsurfaceScattering : MonoBehaviour 
{    
    //Camera which renders the DepthMap
    [SerializeField]
    private Camera m_camDepthCamera;
    
    //Light which is represented by the camera
    [SerializeField]
    private Light m_lightScatterLight;

    //RenderTexture which receives the DepthMap
    [SerializeField]
    private RenderTexture m_texDepthMap;
    
    //Different SubsurfaceScatteringMaterials
    public Material[] m_arrmatSubSurfaceMaterials;

    // Use this for initialization
    void Start () 
    {
        if(m_camDepthCamera == null)
        {
            Debug.LogError("DepthCamera was not assigned");
        }
        if (m_texDepthMap == null)
        {
            Debug.LogError("DepthMap was not assigned");
        }
    }

    //This is on the maincamera, so this is called every frame
    void OnRenderImage(RenderTexture _source, RenderTexture _destination)
    {
        //We have several Materials to show, so we pass the values to all of them
        foreach(Material mat in m_arrmatSubSurfaceMaterials)
        {
            mat.SetTexture("_DepthMap", m_texDepthMap);                             //DeptMap Texture
            mat.SetMatrix("_LightMatrix", m_camDepthCamera.worldToCameraMatrix);    //WorldToCamera Matrix
            mat.SetMatrix("_LightProjectionMatrix", GL.GetGPUProjectionMatrix(m_camDepthCamera.projectionMatrix, false));   //CameraProjectionMatrix
            mat.SetMatrix("_LightTexMatrix", m_camDepthCamera.projectionMatrix * m_camDepthCamera.worldToCameraMatrix);     //Combined MVP Matrix
            mat.SetColor("_LightColor", m_lightScatterLight.color * m_lightScatterLight.intensity);     //The Color of the Light
            mat.SetFloat("_CameraFarPlane", m_camDepthCamera.farClipPlane);     //The cameras FarClipping plane
        }
    }
}
