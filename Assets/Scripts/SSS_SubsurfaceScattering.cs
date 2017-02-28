using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UniRx;

public enum SSSMaterial
{
    Waxy = 0,
    Jade = 1,
    Debug = 2
}

public class SSS_SubsurfaceScattering : MonoBehaviour 
{    
    //Camera which renders the DepthMap
    [SerializeField]
    private Camera m_camDepthCamera;
    [SerializeField]
    private Light m_lightScatterLight;
    //RenderTexture which receives the DepthMap
    [SerializeField]
    private RenderTexture m_texDepthMap;
    
    //Different SubsurfaceScatteringMaterials
    public Material[] m_arrmatSubSurfaceMaterials;

    private void Awake()
    {

    }

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

    void OnPreCull()
    {
        //m_matSubSurfaceMaterial.SetTexture("_DepthMap", m_texDepthMap);
    }

    void OnRenderImage(RenderTexture _source, RenderTexture _destination)
    {
        foreach(Material mat in m_arrmatSubSurfaceMaterials)
        {
            if (m_texDepthMap)
            {
                mat.SetTexture("_DepthMap", m_texDepthMap);
            }
            mat.SetMatrix("_LightMatrix", m_camDepthCamera.worldToCameraMatrix);
            mat.SetMatrix("_LightProjectionMatrix", GL.GetGPUProjectionMatrix(m_camDepthCamera.projectionMatrix, false));
            mat.SetMatrix("_LightTexMatrix", m_camDepthCamera.projectionMatrix * m_camDepthCamera.worldToCameraMatrix);
            mat.SetColor("_LightColor", m_lightScatterLight.color * m_lightScatterLight.intensity);
            mat.SetFloat("_CameraFarPlane", m_camDepthCamera.farClipPlane);
        }
    }
}
